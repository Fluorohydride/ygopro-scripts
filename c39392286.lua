--ハーピィ・パフューマー
function c39392286.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39392286,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,39392286)
	e1:SetTarget(c39392286.thtg)
	e1:SetOperation(c39392286.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--change name
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(76812113)
	c:RegisterEffect(e3)
end
c39392286.card_code_list={12206212}
function c39392286.thfilter(c)
	return aux.IsCodeListed(c,12206212) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c39392286.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x64) and c:IsLevelAbove(5)
end
function c39392286.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39392286.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(c39392286.filter,tp,LOCATION_MZONE,0,1,nil) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c39392286.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c39392286.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	if #g>0 and e:GetLabel()==1 and Duel.SelectYesNo(tp,210) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
	end
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
