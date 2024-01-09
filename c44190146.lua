--デメット爺さん
function c44190146.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44190146,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,44190146)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c44190146.spcost)
	e1:SetTarget(c44190146.sptg)
	e1:SetOperation(c44190146.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44190146,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,44190147)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c44190146.descon)
	e2:SetTarget(c44190146.destg)
	e2:SetOperation(c44190146.desop)
	c:RegisterEffect(e2)
	if not c44190146.global_check then
		c44190146.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DETACH_MATERIAL)
		ge1:SetOperation(c44190146.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
		ge2:SetCondition(c44190146.regop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_END)
		ge3:SetCondition(c44190146.clearop)
		Duel.RegisterEffect(ge3,0)
		c44190146[0]={}
		c44190146[1]={}
	end
end
function c44190146.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 and (r&REASON_COST)>0 then
		local te=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_EFFECT)
		local rc=te:GetHandler()
		if rc:IsRelateToEffect(te) and c44190146[1][rc]~=nil then
			local dg=c44190146[1][rc]-rc:GetOverlayGroup()
			if dg:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
				c44190146[0][rc]=rc:GetFieldID()
			end
		end
	end
	c44190146[1]={}
end
function c44190146.regop(e,tp,eg,ep,ev,re,r,rp)
	if (r&REASON_COST)==REASON_COST and re:IsActiveType(TYPE_XYZ) then
		local rc=re:GetHandler()
		c44190146[1][rc]=rc:GetOverlayGroup()
	end
	return false
end
function c44190146.clearop(e,tp,eg,ep,ev,re,r,rp)
	c44190146[0]={}
	c44190146[1]={}
end
function c44190146.costfilter(c,tp)
	return c:IsCode(75574498) and c:IsFaceup() and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c44190146.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44190146.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local tc=Duel.SelectMatchingCard(tp,c44190146.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c44190146.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c44190146.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44190146.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c44190146.spop(e,tp,eg,ep,ev,re,r,rp)
	local max=2
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.GetMZoneCount(tp)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then max=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c44190146.filter),tp,LOCATION_GRAVE,0,1,max,nil,e,tp)
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c44190146.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(tp) and rc:GetFieldID()==c44190146[0][rc]
end
function c44190146.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rc=re:GetHandler()
	if chk==0 then return rc:IsCanBeEffectTarget(e)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	e:SetLabelObject(rc)
	local dmg=rc:GetRank()*300
	Duel.SetTargetCard(rc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c44190146.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==rc then tc=g:GetNext() end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0
		and rc:IsRelateToEffect(e) and rc:IsFaceup() then
		Duel.Damage(1-tp,rc:GetRank()*300,REASON_EFFECT)
	end
end
