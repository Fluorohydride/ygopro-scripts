--マシンナーズ・フォース
function c58054262.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c58054262.atcost)
	e2:SetOperation(c58054262.atop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58054262,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c58054262.spcost)
	e3:SetTarget(c58054262.sptg)
	e3:SetOperation(c58054262.spop)
	c:RegisterEffect(e3)
end
function c58054262.atcost(e,c,tp)
	return Duel.CheckLPCost(tp,1000)
end
function c58054262.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1000)
end
function c58054262.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c58054262.filter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c58054262.sptargetfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(60999392,23782705,96384007)
end
c58054262.sptarget_list={60999392,23782705,96384007}
function c58054262.sptarget_selector(c,tp,g,sg,i)
	if not c:IsCode(c58054262.sptarget_list[i]) then return false end
	if i<3 then
		sg:AddCard(c)
		g:RemoveCard(c)
		local flag=g:IsExists(c58054262.sptarget_selector,1,nil,tp,g,sg,i+1)
		sg:RemoveCard(c)
		g:AddCard(c)
		return flag
	else
		return true
	end
end
function c58054262.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c22666164.sptargetfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local sg=Group.CreateGroup()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and g:IsExists(c58054262.sptarget_selector,1,nil,tp,g,sg,1)
	end
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:FilterSelect(tp,c58054262.sptarget_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,0,0)
end
function c58054262.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
