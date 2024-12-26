--聖天樹の大母神
---@param c Card
function c92770064.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c92770064.mfilter,2,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92770064,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c92770064.thcon)
	e1:SetTarget(c92770064.thtg)
	e1:SetOperation(c92770064.thop)
	c:RegisterEffect(e1)
	--cannot be battle target and destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92770064,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c92770064.cost)
	e3:SetTarget(c92770064.destg)
	e3:SetOperation(c92770064.desop)
	c:RegisterEffect(e3)
end
function c92770064.mfilter(c)
	return c:IsLinkType(TYPE_LINK)
end
function c92770064.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c92770064.thfilter(c)
	return c:IsSetCard(0x2158) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c92770064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92770064.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c92770064.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c92770064.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c92770064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c92770064.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c92770064.costfilter(c,ec,tp,g)
	return Duel.IsExistingTarget(c92770064.desfilter,tp,0,LOCATION_ONFIELD,1,c,c,ec) and g:IsContains(c) and c:IsType(TYPE_LINK) and c:IsLinkAbove(1)
end
function c92770064.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local ct=0
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c92770064.costfilter,1,c,c,tp,lg)
		else
			return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local g=Duel.SelectReleaseGroup(tp,c92770064.costfilter,1,1,c,c,tp,lg)
		ct=g:GetFirst():GetLink()
		Duel.Release(g,REASON_COST)
	end
	e:SetValue(ct)
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c92770064.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetValue()
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=sg:Select(tp,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
