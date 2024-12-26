--乾燥機塊ドライドレイク
---@param c Card
function c3507053.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x14b),1,1)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c3507053.lmlimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1000)
	e2:SetCondition(c3507053.atkcon)
	c:RegisterEffect(e2)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3507053,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetCondition(c3507053.chcon)
	e3:SetTarget(c3507053.chtg)
	e3:SetOperation(c3507053.chop)
	c:RegisterEffect(e3)
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3507053,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c3507053.negcon)
	e4:SetOperation(c3507053.negop)
	c:RegisterEffect(e4)
end
function c3507053.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c3507053.atkcon(e)
	return e:GetHandler():IsLinkState()
end
function c3507053.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and e:GetHandler():GetMutualLinkedGroupCount()>0 and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end
function c3507053.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x14b) and c:GetSequence()<5
end
function c3507053.fselect(g,c)
	return g:IsContains(c)
end
function c3507053.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c3507053.chfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c3507053.fselect,2,2,e:GetHandler()) end
end
function c3507053.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c3507053.chfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c3507053.fselect,false,2,2,c)
	if sg and sg:GetCount()==2 then
		Duel.HintSelection(sg)
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SwapSequence(tc1,tc2)
		local tc=tc1
		if tc==c then tc=tc2 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c3507053.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()==0
end
function c3507053.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
