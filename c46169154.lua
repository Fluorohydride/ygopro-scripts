--ウォークライ・オーピス
function c46169154.initial_effect(c)
	--normal summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46169154,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c46169154.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tograve & atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46169154,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,46169154)
	e1:SetTarget(c46169154.tgtg)
	e1:SetOperation(c46169154.tgop)
	c:RegisterEffect(e1)
end
function c46169154.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function c46169154.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c46169154.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c46169154.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsAbleToGrave() and not c:IsCode(46169154)
end
function c46169154.check(c,tp)
	return c and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c46169154.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (c46169154.check(Duel.GetAttacker(),tp) or c46169154.check(Duel.GetAttackTarget(),tp))
		and Duel.IsExistingMatchingCard(c46169154.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c46169154.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c46169154.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c46169154.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c46169154.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c46169154.atkfilter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(200)
			tc:RegisterEffect(e1)
		end
	end
end
