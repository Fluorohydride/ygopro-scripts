--E・HERO カオス・ネオス
function c17032740.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,89943723,43237273,17732278,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c17032740.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c17032740.spcon)
	e2:SetOperation(c17032740.spop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17032740,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c17032740.retcon1)
	e3:SetTarget(c17032740.rettg)
	e3:SetOperation(c17032740.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0)
	e4:SetCondition(c17032740.retcon2)
	c:RegisterEffect(e4)
	--coin
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17032740,1))
	e5:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c17032740.coincon)
	e5:SetTarget(c17032740.cointg)
	e5:SetOperation(c17032740.coinop)
	c:RegisterEffect(e5)
end
function c17032740.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c17032740.spfilter(c,code1,code2,code3)
	return c:IsAbleToDeckOrExtraAsCost() and (c:IsFusionCode(code1) or c:IsFusionCode(code2) or c:IsFusionCode(code3))
end
function c17032740.spfilter1(c,mg)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	return c:IsFusionCode(89943723) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c17032740.spfilter2,1,nil,mg2)
end
function c17032740.spfilter2(c,mg)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	return c:IsFusionCode(43237273) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c17032740.spfilter3,1,nil)
end
function c17032740.spfilter3(c)
	return c:IsFusionCode(17732278) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c17032740.rmfilter(c,code)
	return c:IsFusionCode(code) and c:IsCode(code)
end
function c17032740.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	local mg=Duel.GetMatchingGroup(c17032740.spfilter,tp,LOCATION_ONFIELD,0,nil,89943723,43237273,17732278)
	if ft>0 then return mg:IsExists(c17032740.spfilter1,1,nil,mg) end
	local mg2=mg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local ct=mg2:GetClassCount(Card.GetFusionCode)
	if ft==-2 then return ct==3 and mg:IsExists(c17032740.spfilter1,1,nil,mg)
	elseif ft==-1 then return ct>=2 and mg:IsExists(c17032740.spfilter1,1,nil,mg)
	else return ct>=1 and mg:IsExists(c17032740.spfilter1,1,nil,mg) end
end
function c17032740.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg1=Duel.GetMatchingGroup(c17032740.spfilter,tp,LOCATION_ONFIELD,0,nil,89943723,43237273,17732278)
	local mg2=mg1:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if i==1 then
			if ft<=0 then
				tc=mg2:FilterSelect(tp,c17032740.spfilter1,1,1,nil,mg2):GetFirst()
			else
				tc=mg1:FilterSelect(tp,c17032740.spfilter1,1,1,nil,mg1):GetFirst()
			end
		end
		if i==2 then
			if ft<=0 then
				tc=mg2:FilterSelect(tp,c17032740.spfilter2,1,1,nil,mg2):GetFirst()
			else
				tc=mg1:FilterSelect(tp,c17032740.spfilter2,1,1,nil,mg1):GetFirst()
			end
		end
		if i==3 then
			if ft<=0 then
				tc=mg2:FilterSelect(tp,c17032740.spfilter3,1,1,nil,mg2):GetFirst()
			else
				tc=mg1:FilterSelect(tp,c17032740.spfilter3,1,1,nil,mg1):GetFirst()
			end
		end
		g:AddCard(tc)
		if tc:IsFusionCode(89943723) then
			mg1:Remove(c17032740.rmfilter,nil,89943723)
			mg2:Remove(c17032740.rmfilter,nil,89943723)
		elseif tc:IsFusionCode(43237273) then
			mg1:Remove(c17032740.rmfilter,nil,43237273)
			mg2:Remove(c17032740.rmfilter,nil,43237273)
		elseif tc:IsFusionCode(17732278) then
			mg1:Remove(c17032740.rmfilter,nil,17732278)
			mg2:Remove(c17032740.rmfilter,nil,17732278)
		end
		ft=ft+1
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c17032740.retcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(42015635)
end
function c17032740.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
function c17032740.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c17032740.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c17032740.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c17032740.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c17032740.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==3 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif c1+c2+c3==2 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	elseif c1+c2+c3==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
