--神鳥の烈戦
---@param c Card
function c57823578.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c57823578.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c57823578.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(57823578,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,57823578)
	e4:SetCondition(c57823578.thcon)
	e4:SetCost(c57823578.thcost)
	e4:SetTarget(c57823578.thtg)
	e4:SetOperation(c57823578.thop)
	c:RegisterEffect(e4)
end
function c57823578.cfilter(c,atk)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST) and c:GetAttack()>atk
end
function c57823578.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST) and Duel.IsExistingMatchingCard(c57823578.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c57823578.tgtg(e,c)
	return c:IsRace(RACE_WINDBEAST) and Duel.IsExistingMatchingCard(c57823578.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c57823578.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c57823578.costfilter(c)
	return c:GetOriginalLevel()>=7 and c:IsSetCard(0x12d) and c:IsAbleToGraveAsCost()
end
function c57823578.fselect(g,tp,mc)
	local sg=g:Clone()
	sg:AddCard(mc)
	return g:GetClassCount(Card.GetOriginalAttribute)==g:GetCount()
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,sg)
end
function c57823578.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c57823578.costfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return c:IsAbleToGraveAsCost()
		and g:CheckSubGroup(c57823578.fselect,2,2,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c57823578.fselect,false,2,2,tp,c)
	sg:AddCard(c)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c57823578.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c57823578.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local val=Duel.Damage(tp,ct*500,REASON_EFFECT)
		if val>0 and Duel.GetLP(tp)>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
	end
end
