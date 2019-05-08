--ボンディング－D2O
function c79402185.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79402185.cost)
	e1:SetTarget(c79402185.target)
	e1:SetOperation(c79402185.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79402185)
	e2:SetCondition(c79402185.thcon)
	e2:SetTarget(c79402185.thtg)
	e2:SetOperation(c79402185.thop)
	c:RegisterEffect(e2)
end
function c79402185.costfilter(c,tp)
	return c:IsCode(43017476,58071123) and (c:IsControler(tp) or c:IsFaceup())
end
function c79402185.fcheck(c,mg,sg,code,...)
	if not c:IsCode(code) then return false end
	if ... then
		sg:AddCard(c)
		local res=mg:IsExists(c79402185.fcheck,1,sg,mg,sg,...)
		sg:RemoveCard(c)
		return res
	else return true end
end
function c79402185.fselect(g,tp,sg)
	if g:IsExists(c79402185.fcheck,1,nil,g,sg,43017476,43017476,58071123) and Duel.GetMZoneCount(tp,g)>0 then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroupEx(tp,nil,0,nil)
	else return false end
end
function c79402185.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local sg=Group.CreateGroup()
	local g=Duel.GetReleaseGroup(tp,true):Filter(c79402185.costfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(c79402185.fselect,3,3,tp,sg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c79402185.fselect,false,3,3,tp,sg)
	Duel.Release(rg,REASON_COST)
end
function c79402185.filter(c,e,tp)
	return c:IsCode(85066822,6022371) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79402185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c79402185.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c79402185.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79402185.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c79402185.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79402185.thfilter,1,nil)
end
function c79402185.thfilter(c)
	return (c:IsCode(85066822) or c:IsCode(6022371)) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79402185.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c79402185.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
