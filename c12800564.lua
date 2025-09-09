--真竜魔王マスターP
local s,id,o=GetID()
function s.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_CONTINUOUS))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(s.setcon)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.negcon)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	--skip phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id+o)
	e4:SetCondition(s.tpcon)
	e4:SetOperation(s.tpop)
	c:RegisterEffect(e4)
end
function s.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable(REASON_SUMMON)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.setcon(e,c,minc)
	if not c then return true end
	return false
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (LOCATION_HAND+LOCATION_ONFIELD)&loc~=0
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToChain(ev) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.tpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)))
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end

-- guard for "next opponent turn" skips of Main 1
function s.turncon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end

-- helper to schedule a one‑time skip effect
-- code: EFFECT_SKIP_M1 or EFFECT_SKIP_M2
-- next_turn: if true, skips on opponent’s *next* turn (via turncon);
--            if false, skips the upcoming phase *this* turn
function s.schedule_skip(c,tp,code,next_turn)
	local phase=PHASE_MAIN1
	if code==EFFECT_SKIP_M2 then
		phase=PHASE_MAIN2
	end
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(code)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e:SetTargetRange(0,1)
	if next_turn then
		e:SetLabel(Duel.GetTurnCount())
		e:SetCondition(s.turncon)
		-- covers end of this opp turn + end of next opp turn
		e:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		-- reset as soon as that phase would start on their turn, this turn
		e:SetReset(RESET_PHASE+phase+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e,tp)
	return e
end

function s.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=1-tp
	local ph=Duel.GetCurrentPhase()
	local turn_player=Duel.GetTurnPlayer()

	-- My turn → skip their NEXT Main 1 (on turn change)
	if turn_player==tp then
		s.schedule_skip(c,tp,EFFECT_SKIP_M1,true)
		return
	end

	-- Opponent in Battle Phase → skip their upcoming Main 2
	if Duel.IsBattlePhase() then
		s.schedule_skip(c,tp,EFFECT_SKIP_M2,false)
		return
	end

	-- Opponent in Main 1 →
	--    a) schedule skip of *next* Main 1,
	--    b) but pivot to skip M2 if they enter BP
	if ph==PHASE_MAIN1 then
		-- skip their *next* M1
		local skip_m1=s.schedule_skip(c,tp,EFFECT_SKIP_M1,true)

		-- b) watch for BP to cancel M1 skip & schedule M2 skip
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)                   -- PHASE_BATTLE is the end of BP
		e2:SetCountLimit(1)
		e2:SetLabelObject(skip_m1)
		e2:SetOperation(function(ee,tp2,eg2,ep2,ev2,re2,rp2)
			ee:GetLabelObject():Reset()                        -- cancel skip‑M1
			s.schedule_skip(c,tp,EFFECT_SKIP_M2,false)
			ee:Reset()                                         -- destroy watcher
		end)
		-- expires at end of their turn if no BP
		e2:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e2,op)
		return
	end
	-- Opponent in Main 2/EP → skip their *next* Main 1 (on their next turn)
	if ph>=PHASE_MAIN2 then
		s.schedule_skip(c,tp,EFFECT_SKIP_M1,true)
		return
	end
	-- Opponent before Main 1 (Draw/Standby) → skip this turn’s Main 1
	if ph<PHASE_MAIN1 then
		s.schedule_skip(c,tp,EFFECT_SKIP_M1,false)
		return
	end
	assert(false)
end
