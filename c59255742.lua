--ゴヨウ・エンペラー
function c59255742.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c59255742.ffilter,2,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(c59255742.spcon)
	e1:SetTarget(c59255742.sptg)
	e1:SetOperation(c59255742.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c59255742.spcon2)
	e2:SetTarget(c59255742.sptg2)
	e2:SetOperation(c59255742.spop)
	c:RegisterEffect(e2)
	--take control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c59255742.cost)
	e3:SetTarget(c59255742.target)
	e3:SetOperation(c59255742.operation)
	c:RegisterEffect(e3)
	--return control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c59255742.ctcon)
	e4:SetTarget(c59255742.cttg)
	e4:SetOperation(c59255742.ctop)
	c:RegisterEffect(e4)
end
c59255742.material_type=TYPE_SYNCHRO
function c59255742.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsFusionType(TYPE_SYNCHRO)
end
function c59255742.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c59255742.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	return eg:GetCount()==1 and rc:IsControler(tp) and rc:GetOwner()~=tp
		and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and tc:IsLocation(LOCATION_GRAVE)
end
function c59255742.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c59255742.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	local bc=rc:GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c59255742.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c59255742.costfilter(c,tp,g)
	return c59255742.ffilter(c) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and g:IsExists(aux.TRUE,1,c)
end
function c59255742.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c59255742.filter,nil,tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c59255742.costfilter,1,nil,tp,g) end
	local g=Duel.SelectReleaseGroup(tp,c59255742.costfilter,1,1,nil,tp,g)
	Duel.Release(g,REASON_COST)
end
function c59255742.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsControlerCanBeChanged(true)
end
function c59255742.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c59255742.filter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()-1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c59255742.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	Duel.GetControl(g,tp)
end
function c59255742.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c59255742.ctfilter(c)
	return c:GetControler()~=c:GetOwner()
end
function c59255742.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59255742.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c59255742.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and tc:GetFlagEffect(59255742)==0 then
			tc:RegisterFlagEffect(59255742,RESET_EVENT+RESETS_STANDARD,0,1)
			tg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	tg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetEqualFunction(Card.GetFlagEffect,1,59255742))
	e1:SetLabelObject(tg)
	Duel.RegisterEffect(e1,tp)
	--force adjust
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	--reset
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabelObject(e2)
	e3:SetLabel(Duel.GetChainInfo(0,CHAININFO_CHAIN_ID))
	e3:SetOperation(c59255742.reset)
	Duel.RegisterEffect(e3,tp)
end
function c59255742.reset(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==e:GetLabel() then
		local e2=e:GetLabelObject()
		local e1=e2:GetLabelObject()
		local tg=e1:GetLabelObject()
		for tc in aux.Next(tg) do
			tc:ResetFlagEffect(59255742)
		end
		tg:DeleteGroup()
		e1:Reset()
		e2:Reset()
		e:Reset()
	end
end
