--化石融合－フォッシル・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_GRAVE,
		pre_select_mat_opponent_location=LOCATION_GRAVE,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		extra_target=s.extra_target,
		stage_x_operation=s.stage_x_operation
	})
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.cfilter(c,tp)
	return c:IsPreviousSetCard(0x149) and c:GetPreviousTypeOnField()&TYPE_FUSION~=0
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end

function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(s.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(s.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,e:GetLabel())
end

function s.fusfilter(c)
	return c:IsSetCard(0x149)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage,mg_fuison_spell,mg_all)
	if stage==FusionSpell.STAGE_BEFORE_MOVE_MATERIAL then
		local mg_grave=mg_all:Filter(function(c) return c:IsLocation(LOCATION_GRAVE) end,nil)
		if mg_grave:IsExists(function(c) return c:IsControler(tp) end,1,nil) and mg_grave:IsExists(function(c) return c:IsControler(1-tp) end,1,nil) then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
	elseif stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE and e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.efilter)
		tc:RegisterEffect(e1,true)
	end
end

function s.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
