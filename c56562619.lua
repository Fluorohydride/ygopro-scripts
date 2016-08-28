--黒竜の忍者
function c56562619.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c56562619.splimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56562619,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1)
	e2:SetCost(c56562619.rmcost)
	e2:SetTarget(c56562619.rmtg)
	e2:SetOperation(c56562619.rmop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56562619,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c56562619.spcon)
	e3:SetTarget(c56562619.sptg)
	e3:SetOperation(c56562619.spop)
	c:RegisterEffect(e3)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e3:SetLabelObject(ng)
	e2:SetLabelObject(e3)
end
function c56562619.splimit(e,se,sp,st)
	return (se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsSetCard(0x2b)) or se:GetHandler():IsSetCard(0x61)
end
function c56562619.cfilter1(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b) and c:IsAbleToGraveAsCost()
end
function c56562619.cfilter2(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x61) and c:IsAbleToGraveAsCost()
end
function c56562619.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56562619.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c56562619.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c56562619.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c56562619.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c56562619.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c56562619.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(56562619,RESET_EVENT+0x1fe0000,0,0)
		e:GetLabelObject():SetLabel(1)
		if c:GetFlagEffect(56562619)==0 then
			c:RegisterFlagEffect(56562619,RESET_EVENT+0x1680000,0,0)
			e:GetLabelObject():GetLabelObject():Clear()
		end
		e:GetLabelObject():GetLabelObject():AddCard(tc)
	end
end
function c56562619.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=e:GetLabelObject()
	local act=e:GetLabel()
	e:SetLabel(0)
	if act==1 and c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
		and c:GetFlagEffect(56562619)~=0 then return true
	else rg:Clear() return false end
end
function c56562619.spfilter(c,e,tp)
	return c:GetFlagEffect(56562619)~=0 
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,1-tp))
end
function c56562619.spfilter1(c,e,tp)
	return c:GetFlagEffect(56562619)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOwner()==tp
end
function c56562619.spfilter2(c,e,tp)
	return c:GetFlagEffect(56562619)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,1-tp) and c:GetOwner()==1-tp
end
function c56562619.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetLabelObject()
	if chk==0 then
		if rg:IsExists(c56562619.spfilter,1,nil,e,tp) then return true
		else rg:Clear() return false end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rg,rg:GetCount(),0,0)
end
function c56562619.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local rg=e:GetLabelObject()
	if (ft1<=0 and ft2<=0) or rg:GetCount()<=0 then return end
	local sg=nil
	local sg1=rg:Filter(c56562619.spfilter1,nil,e,tp)
	local sg2=rg:Filter(c56562619.spfilter2,nil,e,tp)
	local gc1=sg1:GetCount()
	local gc2=sg2:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if ft1<=0 and gc2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg2:Select(tp,1,1,nil)
		elseif ft2<=0 and gc1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg1:Select(tp,1,1,nil)
		elseif (gc1>0 and ft1>0) or (gc2>0 and ft2>0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=rg:FilterSelect(tp,c56562619.spfilter,1,1,nil,e,tp)
		end
		if sg~=nil then
			Duel.SpecialSummon(sg,0,tp,sg:GetFirst():GetOwner(),false,false,POS_FACEUP)
		end
		rg:Clear()
		return
	end
	if gc1>0 and ft1>0 then
		if sg1:GetCount()>ft1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg1=sg1:Select(tp,ft1,ft1,nil)
		end
		local sg=sg1:GetFirst()
		while sg do
			Duel.SpecialSummonStep(sg,0,tp,tp,false,false,POS_FACEUP)
			sg=sg1:GetNext()
		end
	end
	if gc2>0 and ft2>0 then
		if sg2:GetCount()>ft2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg2=sg2:Select(tp,ft2,ft2,nil)
		end
		local sg=sg2:GetFirst()
		while sg do
			Duel.SpecialSummonStep(sg,0,tp,1-tp,false,false,POS_FACEUP)
			sg=sg2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
	rg:Clear()
end
