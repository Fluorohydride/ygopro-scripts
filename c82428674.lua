--サイバネティック・オーバーフロー
---@param c Card
function c82428674.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82428674)
	e1:SetTarget(c82428674.target)
	e1:SetOperation(c82428674.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,82428675)
	e2:SetCondition(c82428674.thcon)
	e2:SetTarget(c82428674.thtg)
	e2:SetOperation(c82428674.thop)
	c:RegisterEffect(e2)
end
function c82428674.rmfilter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsCode(70095154) and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c82428674.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82428674.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82428674.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct=dg:GetCount()
	local g=Duel.GetMatchingGroup(c82428674.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	if ct==0 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.dlvcheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,1,ct)
	aux.GCheckAdditional=nil
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	if rc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,rc,rc,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c82428674.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(r,REASON_EFFECT)~=0
end
function c82428674.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x94,0x93) and c:IsAbleToHand()
end
function c82428674.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82428674.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82428674.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82428674.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
