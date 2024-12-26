--RUM－千死蛮巧
---@param c Card
function c96142517.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c96142517.cost)
	e1:SetTarget(c96142517.target)
	e1:SetOperation(c96142517.activate)
	c:RegisterEffect(e1)
end
function c96142517.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c96142517.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c96142517.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetHandler()~=se:GetHandler()
end
function c96142517.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ) and c:IsCanOverlay() and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c96142517.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk+1)
end
function c96142517.spfilter(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x1048,0x1073) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c96142517.gcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c96142517.fselect(g,e,tp)
	if not g:IsExists(Card.IsControler,1,nil,tp) or not g:IsExists(Card.IsControler,1,nil,1-tp) then return false end
	local mg=Duel.GetMatchingGroup(c96142517.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,9)
	return not g:GetFirst():IsRank(8)
		or mg:IsExists(aux.NOT(Card.IsOriginalCodeRule),1,nil,6165656) or g:IsExists(Card.IsCode,1,nil,48995978)
end
function c96142517.spfilter2(c,e,tp,rk,tg)
	return c96142517.spfilter(c,e,tp,rk) and (not c:IsOriginalCodeRule(6165656) or tg:IsExists(Card.IsCode,1,nil,48995978))
end
function c96142517.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c96142517.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return false end
	if chk==0 then
		aux.GCheckAdditional=c96142517.gcheck
		local res=g:CheckSubGroup(c96142517.fselect,2,#g,e,tp)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	aux.GCheckAdditional=c96142517.gcheck
	local g1=g:SelectSubGroup(tp,c96142517.fselect,false,2,#g,e,tp)
	aux.GCheckAdditional=nil
	Duel.SetTargetCard(g1)
	local rk=g1:GetFirst():GetRank()
	e:SetLabel(rk)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c96142517.activate(e,tp,eg,ep,ev,re,r,rp)
	local rk=e:GetLabel()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96142517.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk+1,tg)
	local sc=g:GetFirst()
	if sc then
		local og=mg:Filter(Card.IsCanOverlay,nil)
		Duel.Overlay(sc,og)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
