--Rustin Mammoth
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.thcon2)
	c:RegisterEffect(e3)
end
function s.rfilter(c)
	return c:IsLinkAbove(1) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function s.fselect(g)
	return g:GetSum(Card.GetLink)==5
end
function s.gcheck(g)
	return g:GetSum(Card.GetLink)<=5
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_EXTRA,0,nil)
	aux.GCheckAdditional=s.gcheck
	if chk==0 then
		local res=g:CheckSubGroup(s.fselect,1,g:GetCount(),tp)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,s.fselect,false,1,g:GetCount(),tp)
	aux.GCheckAdditional=nil
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.ecfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLinkAbove(3) and c:IsType(TYPE_LINK)
end
function s.getlg(tp)
	local lg=Duel.GetMatchingGroup(s.ecfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lg2=Group.CreateGroup()
	for lc in aux.Next(lg) do
		lg2:Merge(lc:GetLinkedGroup())
	end
	return lg2
end
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local lg2=s.getlg(tp)
	return not lg2 or not lg2:IsContains(e:GetHandler())
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local lg2=s.getlg(tp)
	return lg2 and lg2:IsContains(e:GetHandler())
end
function s.thfilter(c,e)
	return c:IsAbleToHand()
		and c:IsCanBeEffectTarget(e)
end
function s.gcheck2(g,tp)
	return g:FilterCount(Card.IsControler,nil,tp)==g:FilterCount(Card.IsControler,nil,1-tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return g:CheckSubGroup(s.gcheck2,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,s.gcheck2,false,2,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain():Filter(Card.IsOnField,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
